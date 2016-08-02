
package com.incheck
{
	import com.incheck.common.ICNode;

	import mx.controls.Tree;


	public class StructureTree extends Tree
	{

//		private var _dp:com.incheck.IncheckDataProvider = new com.incheck.IncheckDataProvider();

		[Embed("/assets/ledgreen.png")]
		public static var ok:Class;

		[Embed("/assets/ledyellow.png")]
		public static var warn:Class;

		[Embed("/assets/ledred.png")]
		public static var error:Class;

		[Embed("/assets/ledblue.png")]
		public static var disabled:Class;


		public function StructureTree()
		{
			super();
			/*
			labelField="@label" ;
			showRoot= true;
			//setStyle("itemRenderer", new TreeRenderer());
			var structure:XMLList = new XMLList(_dp.getTreeStructure());
			var data:ICollectionView = new XMLListCollection(structure);
			dataProvider = data;
			*/
			dataDescriptor = new TreeDataDescriptor();

			this.setStyle("fontFamily", "Verdana");
			this.setStyle("fontSize", "12");
//			this.setStyle("fontWeight","bold");

		}


		public static function icIconFunction(item:ICNode):Class
		{

//			if(item.type=='Channel' && (item.processedDataKeysString==null || item.processedDataKeysString.length==0)){
			if (item.type != 'Channel')
			{
				item.state = -1;
				return disabled;
			}
			if (item.state == 0)
			{
				return ok;
			}
			else if (item.state == 1)
			{
				return warn;
			}
			else if (item.state == 2)
			{
				return error;
			}
			else
			{
				return disabled;
			}

		}
	}
}
