package system.ui
{
	import flash.display.Sprite;
	
	public class Panel extends Sprite
	{
		public var isLoaded:Boolean = false;
		private var _panelName:String = "";
		public function Panel()
		{
			super();
		}
		
		public function onCreate():void{
			
		}
		
		public function onStart():void{
			
		}
		
		public function getResUrl():Array{
			return [];
		}
		
		public function onClose():void{
		}
		
		public function onDestroy():void{
			
		}
		
		public function setPanelName(panelName:String):void{
			_panelName = panelName;
		}
		
		public function getPanelName():String{
			return _panelName;
		}
		
		/**重新定义自己的布局**/
		public function reLayout():void{
			
		}
	}
}