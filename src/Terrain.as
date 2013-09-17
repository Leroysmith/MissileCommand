package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Leroy Smith
	 */
	public class Terrain  extends MovieClip
	{
		public var art:MovieClip
		
		public function Terrain() 
		{
			art = new TerrainArt();
			addChild(art);
		}
		
	}

}