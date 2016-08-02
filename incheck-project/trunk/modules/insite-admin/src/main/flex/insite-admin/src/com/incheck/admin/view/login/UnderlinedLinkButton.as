package com.incheck.admin.view.login
{
	import flash.events.MouseEvent;
	import mx.controls.LinkButton;

	public class UnderlinedLinkButton extends LinkButton
	{
		public function UnderlinedLinkButton()
		{
			super();
			setStyle("skin", null);
			setStyle("fontWeight", "normal");
			setStyle("textDecoration", "none");
		}
		
		override protected function rollOverHandler(event:MouseEvent):void
		{
			super.rollOverHandler(event);
			setStyle("textDecoration", "underline");
		}
		
		override protected function rollOutHandler(event:MouseEvent):void
		{
			super.rollOutHandler(event);
			setStyle("textDecoration", "none");
		}
	}
}