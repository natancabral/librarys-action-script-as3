package GNNC.application
{
	//http://help.adobe.com/pt_BR/FlashPlatform/reference/actionscript/3/flash/display/NativeWindow.html
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.events.Event;
	
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.*;
	import mx.managers.WindowedSystemManager;
	
	[Event(name="creationComplete", type="mx.events.FlexEvent")] 
	
	public class ExtendedNativeWindow extends NativeWindow
	{
		private var _systemManager:WindowedSystemManager;
		private var _content:IVisualElement;
		
		public function ExtendedNativeWindow(initOptions:NativeWindowInitOptions = null)
		{
			//* Call the base class constructor
			super(initOptions);
			//* Add in a listener for the Activate event - this is where we add in the content
			addEventListener(Event.ACTIVATE, windowActivateHandler);
		}
		
		//* Custom function to allow the content to be passed into the window
		public function addChildControls(control:IVisualElement):void
		{
			_content = control;
		}
		
		//* This handler actually adds the content to the NativeWindow
		private function windowActivateHandler(event:Event):void
		{
			//* Process the event
			event.preventDefault();
			event.stopImmediatePropagation();
			removeEventListener(Event.ACTIVATE, windowActivateHandler);
			
			//* Create the children and add an event listener for re-sizing the window
			if(stage)
			{
				//* create a WindowedSystemManager to hold the content
				if(!_systemManager)
				{
					//*    Create a system manager
					_systemManager = new WindowedSystemManager(_content as IUIComponent);
				}
				
				//* Add the content to the stage
				stage.addChild(_systemManager);
				
				//* Dispatch a creation complete event
				dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
				
				//* Add in a resize event listener
				stage.addEventListener(Event.RESIZE, windowResizeHandler);
			}
		}
		
		//* Resizes the content in response to a change in size
		private function windowResizeHandler(event:Event):void
		{
			_content.width = stage.stageWidth;
			_content.height = stage.stageHeight;
		}
	}
}