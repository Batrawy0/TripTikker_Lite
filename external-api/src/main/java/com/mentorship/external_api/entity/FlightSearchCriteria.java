package com.mentorship.external_api.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FlightSearchCriteria {

    private String origin;
    private String destination;
    private String departDate;
    private String returnDate;
    private String adults;

    public static FlightSearchCriteria createFlightSearchCriteria(String origin, String destination, String departDate,
                                                                  String returnDate, String adults) {
        return FlightSearchCriteria.builder().origin(origin).destination(destination).departDate(departDate).returnDate(returnDate)
                .adults(adults).build();
    }
}
