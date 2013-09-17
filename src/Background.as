package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Leroy Smith
	 */
	public class Background  extends MovieClip
	{
		public var art:MovieClip;
		
		public function Background() 
		{
			art = new BackgroundArt();
			addChild(art);
		}
		
	}

}