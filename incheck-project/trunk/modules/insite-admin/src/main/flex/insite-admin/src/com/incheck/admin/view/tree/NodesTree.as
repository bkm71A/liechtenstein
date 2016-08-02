package com.incheck.admin.view.tree {
import com.incheck.admin.model.TreeNode;

import mx.controls.Tree;

public class NodesTree extends Tree
{

    [Embed("/../imgs/ledgreen.png")]
    public static var ok:Class;
    [Embed("/../imgs/ledyellow.png")]
    public static var warn:Class;
    [Embed("/../imgs/ledred.png")]
    public static var error:Class;
    [Embed("/../imgs/ledblue.png")]
    public static var disabled:Class;


    public function NodesTree(){
        super();
        dataDescriptor = new NodesTreeDataDescriptor();
    }

    public static function icIconFunction(item:TreeNode):Class{

        if(item.state==0){
            return ok;
        }else if(item.state==1){
            return warn;
        }else if(item.state==2){
            return error;
        }else{
            return disabled;
        }

    }
}
}
