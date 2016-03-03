package system.ui
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import game.PlayPanel;
	import game.StartPanel;
	
	import system.loader.LoaderListListener;
	import system.loader.LoaderManager;

	public class PanelManager
	{
		private static var _instance:PanelManager = null;
		private var _panelLayer:Sprite;
		
		/**
		 * 已被创建的面板列表
		 * */
		private var _activityPanels:Dictionary;
		
		private var _usedPanelList:Dictionary;
		private var _panelCSList:Dictionary;
		
		public function PanelManager()
		{
			_activityPanels = new Dictionary();
			_usedPanelList = new Dictionary();
			_panelCSList = new Dictionary();
		}
		
		/**
		 * 面板注册
		 * */
		public function registerPanel(panelName:String,panelCls:Class):void{
			_panelCSList[panelName] = panelCls;
		}
		
		public static function instance():PanelManager{
			if(!_instance)
				_instance = new PanelManager();
			return _instance;
		}
		
		public function setUp(panelLayer:Sprite):void{
			_panelLayer = panelLayer;
		}
		
		public  function showPanel(panelName:String):void{
			var panel:Panel;
			var loadManager:LoaderManager = LoaderManager.instance();
			if(_activityPanels.hasOwnProperty(panelName)){
				panel = _activityPanels[panelName];
			}else{
				panel = _activityPanels[panelName] = new _panelCSList[panelName]();
				panel.setPanelName(panelName);
			}
			if(_usedPanelList[panelName]){
				//todo switch to top .. resume
			}else if(!panel.isLoaded){
				loadPanel(panel);
			}else{
				addChild(panel);
			}
		}
		
		
		
		public function closePanel(panelName:String):void{
			if(_usedPanelList[panelName]){
				var panel:Panel = _usedPanelList[panelName];
				panel.onClose();
				delete _usedPanelList[panelName];
				removeChild(panel);
			}
		}
		
		public function removeChild(panel:Panel):void{
			panel.visible = false;
			_panelLayer.removeChild(panel);
		}
		
		private function addChild(panel:Panel):void
		{
			trace("[添加面板] "+panel.getPanelName());
			panel.visible = true;
			_usedPanelList[panel.getPanelName()] = panel;
			panel.reLayout();
			_panelLayer.addChild(panel);
			panel.onStart();
		}
		
		private function loadPanel(panel:Panel):void
		{
			var resUrl:Array = panel.getResUrl();
			LoaderManager.instance().loadResList(resUrl,function (lLL:LoaderListListener):void{
				panel.isLoaded = true;
				panel.onCreate();
				addChild(panel);
			});
			
		}
	}
}