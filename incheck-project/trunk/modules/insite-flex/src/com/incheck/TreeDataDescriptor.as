package com.incheck
{
	import mx.controls.treeClasses.DefaultDataDescriptor;
	import mx.controls.treeClasses.ITreeDataDescriptor;

	public class TreeDataDescriptor extends DefaultDataDescriptor implements ITreeDataDescriptor
	{
		
		public static var NODE_TYPE_LOCATION:String = "Loc";
		public static var NODE_TYPE_MACHINE:String = "Machine";
		public static var NODE_TYPE_POINT:String = "Point";
		public static var NODE_TYPE_CHANNEL:String = "Channel";
		
		public override function isBranch(node:Object, model:Object=null):Boolean{
		if (node == null)
			return false;
			
		var branch:Boolean = false;
			
		if (node is XML)
		{
			var childList:XMLList = node.children();
			//accessing non-required e4x attributes is quirky
			//but we know we'll at least get an XMLList
			var branchFlag:XMLList = node.@isBranch;
			//check to see if a flag has been set
			if (branchFlag.length() == 1)
			{
				//check flag and return (this flag overrides termination status)
				if (branchFlag[0] == "true")
			    	branch = true;
			}
			//since no flags, we'll check to see if there are children
			else if (childList.length() != 0)
			{
				branch = true;
			}
		}
		else if (node is Object)
		{
			try
			{
				/*
				if (node.children != undefined)
				{
					branch = true;
				}
				*/
				
				if(node.type != NODE_TYPE_CHANNEL){
					branch = true;
				}
			}
			catch (e:Error)
			{
			}
		}
		return branch;
	}
	}
}