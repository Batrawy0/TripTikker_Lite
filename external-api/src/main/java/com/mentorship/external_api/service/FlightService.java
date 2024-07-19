package com.mentorship.external_api.service;

import com.amadeus.Amadeus;
import com.amadeus.Params;
import com.amadeus.exceptions.ResponseException;
import com.amadeus.resources.FlightOfferSearch;
import com.mentorship.external_api.entity.FlightSearchCriteria;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import javax.net.ssl.*;
import java.security.cert.X509Certificate;
import java.util.Arrays;

@Service
public class FlightService {

    private static final Logger logger = LoggerFactory.getLogger(FlightService.class);
    private final Amadeus amadeus;

    @Autowired
    public FlightService(Amadeus amadeus) {
        this.amadeus = amadeus;
    }

    public static void disableSSLCertificateChecking() {
        try {
            TrustManager[] trustAllCertificates = new TrustManager[]{
                    new X509TrustManager() {
                        public X509Certificate[] getAcceptedIssuers() {
                            return null;
                        }

                        public void checkClientTrusted(X509Certificate[] certs, String authType) {
                        }

                        public void checkServerTrusted(X509Certificate[] certs, String authType) {
                        }
                    }
            };

            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(null, trustAllCertificates, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.getSocketFactory());

            HostnameVerifier allHostsValid = new HostnameVerifier() {
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            };

            HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Cacheable(value = "flightSearchData", key = "#guestUserId + '-' + #searchCriteria.hashCode()")
    public String searchFlights(String guestUserId, FlightSearchCriteria searchCriteria) throws ResponseException {
        disableSSLCertificateChecking();
        FlightOfferSearch[] flightOfferSearches;
        Params params = Params.with("originLocationCode", searchCriteria.getOrigin())
                .and("destinationLocationCode", searchCriteria.getDestination())
                .and("departureDate", searchCriteria.getDepartDate())
                .and("returnDate", searchCriteria.getReturnDate())
                .and("adults", searchCriteria.getAdults())
                .and("max", 3);

        try {
            flightOfferSearches = amadeus.shopping.flightOffersSearch.get(params);
        } catch (ResponseException e) {
            logger.error("Error fetching flight offers: {}", e.getMessage());
            throw e;
        }
        return Arrays.toString(flightOfferSearches);
    }
}
