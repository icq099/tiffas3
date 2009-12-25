package
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.objects.parsers.Collada;
	import org.papervision3d.view.BasicView;

	public class DaeViewer extends UIComponent
	{
		public var view_port:BasicView=new BasicView();
		private var dae:Collada;
		public function DaeViewer()
		{
			super();
			view_port.viewport.autoScaleToStage=false;
			addChild(view_port);
			view_port.startRendering();
			measuredWidth=500;
			measuredHeight=300;
			addEventListener("widthChanged",onWidthChanged);
			addEventListener("heightChanged",onHeightChanged);
			initDisplay();
		}
		private function initDisplay():void{
			var lines:Lines3D=new Lines3D(new LineMaterial());
			for(var i:int=0;i<100;i++){
				lines.addLine(new Line3D(lines,new LineMaterial(0xff0000),2,new Vertex3D(i*10),new Vertex3D((i+1)*10,0,0)));
				lines.addLine(new Line3D(lines,new LineMaterial(0x00ff00),2,new Vertex3D(0,i*10),new Vertex3D(0,(i+1)*10,0)));
				lines.addLine(new Line3D(lines,new LineMaterial(0x0000ff),2,new Vertex3D(0,0,i*10),new Vertex3D(0,0,(i+1)*10)));
			}
			view_port.scene.addChild(lines);
		}
		public function set source(in_source:Object):void{
			try{
				view_port.scene.removeChild(dae);
			}catch(e:Error){
			}
			dae=new Collada(String(in_source));
			view_port.scene.addChild(dae);
		}
		public function set scale(value:Number):void{
			dae.scale=value;
		}
		private function onWidthChanged(e:Event):void{
			view_port.viewport.viewportWidth=width;
		}
		private function onHeightChanged(e:Event):void{
			view_port.viewport.viewportHeight=height;
		}
		
	}
}