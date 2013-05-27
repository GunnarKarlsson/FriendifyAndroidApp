package com.squidzoo.friendify.customComponents
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.events.FlexEvent;

	import spark.components.Button;
	import spark.components.RichEditableText;
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;

	public class ClearableTextInput extends TextInput
	{

		[SkinPart(required="false")]
		public var clearButton:Button;

		public function ClearableTextInput()
		{
			super();

			this.addEventListener(FlexEvent.VALUE_COMMIT, textChangedHandler, false, 0, true);

			this.addEventListener(TextOperationEvent.CHANGE, textChangedHandler, false, 0, true);
		}

		public function cleanUp():void
		{
			if (this.hasEventListener(FlexEvent.VALUE_COMMIT))
			{
				this.removeEventListener(FlexEvent.VALUE_COMMIT, textChangedHandler);
			}
			if (this.hasEventListener(TextOperationEvent.CHANGE))
			{
				this.removeEventListener(TextOperationEvent.CHANGE, textChangedHandler);
			}
			if (clearButton && clearButton.hasEventListener(MouseEvent.CLICK))
			{
				clearButton.removeEventListener(MouseEvent.CLICK, clearClick);
			}
		}

		private function textChangedHandler(e:Event):void
		{
			(promptDisplay as RichEditableText).visible=false;

			if (clearButton)
			{
				clearButton.visible=(text.length > 0);
			}
		}

		private function clearClick(e:MouseEvent):void
		{
			text='';
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);

			if (instance == clearButton)
			{
				clearButton.addEventListener(MouseEvent.CLICK, clearClick);
				clearButton.visible=(text != null && text.length > 0);
			}

			if (instance == textDisplay)
			{
				textDisplay.multiline=false;

				textDisplay.lineBreak="explicit";

				// TextInput always 1 line.
				if (textDisplay is RichEditableText)
					RichEditableText(textDisplay).heightInLines=1;
			}
		}

		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);

			if (instance == clearButton)
			{
				clearButton.removeEventListener(MouseEvent.CLICK, clearClick);
			}
		}
	}
}
