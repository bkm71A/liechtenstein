package com.inchecktech.dpm.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.inchecktech.dpm.engine.DPMEngine;
import com.inchecktech.dpm.utils.Logger;

/**
 * Servlet implementation class for Servlet: TestServlet
 *
 */
 public class InitServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {
   static final long serialVersionUID = 1L;
   
    /* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public InitServlet() {
		super();
		System.out.println("InitServlet\n\n");
		new Thread(new Runnable() {
		    public void run() {
		      try {
		    	  //initialize the logger
		    	  Logger.init();
		    	  
		    	  DPMEngine.main(null);
		    	  
		      }
		      catch(Throwable ex) { ex.printStackTrace();}
		    }
		  }).start();
		
	}   	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}  	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}   	  	  
	
	/* (non-Javadoc)
	 * @see javax.servlet.GenericServlet#init()
	 */
	public void init() throws ServletException {
		// TODO Auto-generated method stub
		super.init();
	}   
}