package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Leroy Smith
	 */
	public class Enemy  extends MovieClip
	{
		private var art:MovieClip;
		
		public function Enemy() 
		{
			art = new AsteroidArt();
			addChild(art)
		}
		
	}

}