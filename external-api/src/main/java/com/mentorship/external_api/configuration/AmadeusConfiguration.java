package com.mentorship.external_api.configuration;

import com.amadeus.Amadeus;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AmadeusConfiguration {

    @Value("${amadeus.clientId}")
    private String clientId;

    @Value("${amadeus.clientSecret}")
    private String clientSecret;

    @Bean
    public Amadeus amadeus() {
        return Amadeus.builder(clientId, clientSecret)
                .build();
    }
}
