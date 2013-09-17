package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Leroy Smith
	 */
	public class Player  extends MovieClip
	{
		private var art:MovieClip;
		
		public function Player() 
		{
			art = new TurretArt();
			addChild(art);
		}
		
	}

}