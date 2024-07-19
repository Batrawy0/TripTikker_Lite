package com.mentorship.external_api.controller;

import com.amadeus.exceptions.ResponseException;
import com.mentorship.external_api.entity.FlightSearchCriteria;
import com.mentorship.external_api.service.FlightService;
import com.mentorship.external_api.utils.GuestUserIdGenerator;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/flights")
public class FlightController {

    private final FlightService flightService;

    @Autowired
    public FlightController(FlightService flightService) {
        this.flightService = flightService;
    }

    @GetMapping("/search")
    public String flights(HttpServletRequest request,
                          HttpServletResponse response,
                          @RequestParam(required = true) String origin,
                          @RequestParam(required = true) String destination,
                          @RequestParam(required = true) String departDate,
                          @RequestParam(required = true) String adults,
                          @RequestParam(required = false) String returnDate)
            throws ResponseException {
        FlightSearchCriteria searchCriteria = FlightSearchCriteria.createFlightSearchCriteria(origin, destination, departDate, returnDate, adults);

        String guestUserId = GuestUserIdGenerator.generateGuestUserId(request , response);
        log.info("guestUserId : {} " , guestUserId);
        return flightService.searchFlights(guestUserId, searchCriteria);
    }
}
