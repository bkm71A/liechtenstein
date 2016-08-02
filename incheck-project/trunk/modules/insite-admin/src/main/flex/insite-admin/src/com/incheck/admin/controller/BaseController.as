package com.incheck.admin.controller {
import com.incheck.admin.service.AdminService;

import flash.events.EventDispatcher;

public class BaseController extends EventDispatcher {

    protected var service : AdminService;
    protected var isNew : Boolean;

    public function BaseController() {
    }


}
}
