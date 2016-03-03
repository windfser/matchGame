package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.Game;
	
	[SWF(backgroundColor="0",frameRate="60",width="408",height="660")]
	public class Main extends Sprite
	{
		public function Main()
		{
			if(stage){
				init();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		
		/**
		 * @author fengsser
		 * 启动游戏
		 * */
		private function init():void{
			if(this.hasEventListener(Event.ADDED_TO_STAGE)){
				this.removeEventListener(Event.ADDED_TO_STAGE,init);
			}
			Game.instance().setUp(this);
		}
	}
}