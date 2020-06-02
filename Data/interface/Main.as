package Metro.GearWidget
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import hudframework.IHUDWidget;
	import Metro.Log;

	public class Main extends MovieClip implements IHUDWidget
	{
		public var Gear_mc:MovieClip;
	//	public var Geiger_mc:MovieClip;

		// text fields
		public var Charge_tf:TextField;
		public var Quantity_tf:TextField;
		public var Status_tf:TextField;



		private var timer:Timer;

		private static const WIDGET_IDENTIFIER:String = "GearWidget.swf";
		
		private static const Command_MaskStatus:String = "StatusMaskCommand";
		private static const Command_Status:String = "StatusCommand";
		
		private static const StatusUndamaged:String = "Undamaged";
		private static const StatusMinor:String = "Minor Damage";
		private static const StatusModerate:String = "Moderate Damage";
		private static const StatusSevere:String = "Severe Damage";
		private static const StatusBroken:String = "Broken"
		
		private static const StatusNormal:String = "Normal";
		private static const StatusDegraded:String = "Degraded";
		private static const StatusConsumed:String = "Consumed";
		private static const StatusReplaced:String = "Replaced";

		private static const Command_UpdateCharge:int = 100;
		private static const Command_UpdateQuantity:int = 200;

		private static const Command_UpdateRadiation:int = 300;
		private static const Command_UpdateGeiger:int = 400;


		public function Main()
		{
			super();
		}


		public function processMessage(command:String, params:Array):void
		{
			Log.WriteLine("processMessage(command:'"+command+"', params:'"+params[0]+"')");

			switch(command)
			{
				case String(Command_UpdateCharge):
					Charge_tf.text = String(params[0]);
					break;

				case String(Command_UpdateQuantity):
					Quantity_tf.text = String(params[0]);
					break;

//				case String(Command_UpdateRadiation):
//					Geiger_mc.HandleUpdateRadiation(params);
//					Status_tf.text = "RADIATION";
//					break;
//				case String(Command_UpdateGeiger):
//					Geiger_mc.HandleUpdateGeiger(params);
//					Status_tf.text = "GEIGER";
//					break;
				
				case String(Command_MaskStatus):
					Status_tf.text = String(params[0]);
					break;

				case String(Command_Status):
					var sFrameLabel:String = params[0]
					switch(sFrameLabel)
					{
						case String(StatusNormal):
							Gear_mc.gotoAndStop(StatusNormal);
							break;

						case String(StatusDegraded):
							Gear_mc.gotoAndPlay(StatusDegraded);
							break;

						case String(StatusConsumed):
							Gear_mc.gotoAndPlay(StatusConsumed);
							break;

						case String(StatusReplaced):
							Gear_mc.gotoAndPlay(StatusReplaced);
							break;
					}
				
			}
		}

	}
}
