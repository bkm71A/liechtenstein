package com.incheck.admin.view.modules {
import com.incheck.admin.model.Module;

public interface IModules {
    function whenSaveModule(func:Function):void;

    function editModule(module : Module) : void
}
}