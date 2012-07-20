package 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author yoyi
	 */
	public class Main extends Sprite 
	{
		
		private var qTxt:TextField;
		private var resultTxt:TextField;
		private var searchBtn:Sprite;
		
		private var indexLoader:URLLoader;
		private var dicLoader:URLLoader;
		
		private var indexData:ByteArray;
		private var dicData:ByteArray;
		private var endByte:ByteArray;
		
		private var wordList:Array;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			qTxt = new TextField();
			qTxt.multiline = false;
			qTxt.wordWrap = false;
			qTxt.width = 200;
			qTxt.height = 25;
			qTxt.x = 20;
			qTxt.y = 10
			qTxt.type = TextFieldType.INPUT;
			//qTxt.autoSize = TextFieldAutoSize.LEFT;
			qTxt.border = true;
			addChild(qTxt);
			resultTxt = new TextField();
			resultTxt.multiline = true;
			resultTxt.wordWrap = true;
			resultTxt.width = 500;
			resultTxt.height = 300;
			resultTxt.border = true;
			resultTxt.type=TextFieldType.INPUT
			//resultTxt.autoSize = TextFieldAutoSize.LEFT;
			addChild(resultTxt);
			resultTxt.y = 50;
			resultTxt.x = 20;
			
			searchBtn = new Sprite();
			searchBtn.graphics.lineStyle(2);
			searchBtn.graphics.beginFill(0xcccccc);
			searchBtn.graphics.drawRect(0, 0, 50, 20);
			searchBtn.x = 250;
			searchBtn.y = 10;
			addChild(searchBtn);
			searchBtn.addEventListener("click", searchBtnClickHandler);
			
			var indexFile:String = "dic/stardict-oxford-gb-formated-2.4.2/oxford-gb-formated.idx";
			var dicFile:String = "dic/stardict-oxford-gb-formated-2.4.2/oxford-gb-formated.dict"
			//dicFile = "dic/stardict-oxford-gb-formated-2.4.2/aaa.txt";
			
			indexLoader = new URLLoader();
			indexLoader.dataFormat = URLLoaderDataFormat.BINARY;
			indexLoader.addEventListener("complete", indexLoaderCompleteHandler);
			indexLoader.load(new URLRequest(indexFile));
			
			
			dicLoader = new URLLoader();
			dicLoader.dataFormat = URLLoaderDataFormat.BINARY;
			dicLoader.addEventListener("complete", dicLoaderCompleteHandler);
			dicLoader.load(new URLRequest(dicFile));
			
			endByte = new ByteArray();
			endByte.writeUTFBytes('\0');
		}
		
		
		private  function indexLoaderCompleteHandler(evt:Event):void {
			
			indexData = indexLoader.data;
			
			var wordByte:ByteArray = new ByteArray();
			var wordObj:Object = { };
			wordList = [];
			while (indexData.position!=indexData.length) {
				
				var byte:int = indexData.readByte();
				wordByte.writeByte(byte);
				endByte.position = 0;
				if (byte == endByte.readByte()) {
					wordByte.position = 0;
					wordObj.word_str = wordByte;
					wordObj.word_data_offset = indexData.readFloat();
					wordObj.word_data_size = indexData.readFloat();
					wordObj.len = wordByte.length;
					wordList.push(wordObj);
					
					/////get new word///
					wordObj = { };
					wordByte = new ByteArray();
					
				}
				
				
			}
		}
		
		
		private  function dicLoaderCompleteHandler(evt:Event):void {
			
			dicData = dicLoader.data;
			resultTxt.text = "ok";
		}
		
		
		private function searchBtnClickHandler(evt:MouseEvent):void {
			
			var queryTxt:String = qTxt.text;
			resultTxt.text = "";
			
			resultTxt.text = wordList.length+"";
			for (var i:int = 0; i <wordList.length; i++) {
				
				var wByte:ByteArray = wordList[i].word_str as ByteArray ;
				wByte.position = 0;
				var wordStr:String = wByte.readUTFBytes(wByte.length);
				wByte.position = 0;
				var resultStr:String = "没有找到";
				if (wordStr == queryTxt) {
					
					dicData.position = wordList[i].word_data_offset;
					resultStr="aaa"+dicData.readUTFBytes(wordList[i].word_data_offset);
				}
				resultTxt.text += wordStr+" ";
			}
			
			resultTxt.text += resultStr;
		}
		
		private function searchText(queryTxt:String):void {
			
			
			
			
			
		}
		
	}
	
}