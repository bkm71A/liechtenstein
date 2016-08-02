package com.incheck.ng.webapp.servlet;

import javax.servlet.ServletException;

import com.incheck.ng.network.DPMServerSocket;

public class InitServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {
    private static final long serialVersionUID = -366114387444795686L;

    /*
     * (non-Javadoc)
     * 
     * @see javax.servlet.GenericServlet#init()
     */
    public void init() throws ServletException {
        String port = getServletConfig().getInitParameter("socket.port");
        new DPMServerSocket(Integer.parseInt(port)).start();
    }
}
