package com.incheck.ng.service;

import javax.jws.WebService;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

@WebService
@Path("/")
@Produces({"application/json", "application/xml"})
public interface ChannelService {

}
