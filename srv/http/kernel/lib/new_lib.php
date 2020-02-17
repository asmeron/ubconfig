<?php

	class ModuleModel
	{
		protected string $Name;
		protected string $TabDefault;
		protected bool $StatusActive;

		public function getName()
		{
			return $this->Name;
		}

		public function getTabDefault()
		{
			return $this->TabDefault;
		}

		public function isStatusActive()
		{
			return $this->StatusActive;
		}


	}

	class Module extends ModuleModel
	{
		private $Data;
		
		function __construct($IdModule)
		{
			$this->Data = $this->Module_getData($IdModule);

			$this->Name = $this->Module_getName();
			$this->TabDefault = $this->Module_getTabDefault();
			$this->StatusActive = $this->Module_getStatusActive();
		}

		private function Module_getName()
		{
			return $this->Data['Name'];
		}

		private function Module_getTabDefault()
		{
			return $this->Data['Tab'];
		}

		private function Module_getStatusActive()
		{
			if ( $this->Data['Status'] == 'Active')
				return TRUE;
			else
				return FALSE;
		}

		private function Module_getData($IdModule)
		{
			return DataSystem::getDataModule($IdModule);
		}

	}

	class Modules
	{
		public static function getListModules()
		{
			$IdModules = DataSystem::getListModules();

			foreach ($IdModules as $key => $IdModule) 
				$List[$IdModule] = new Module($IdModule);

			return $List;
		}


	}

	class DataSystem
	{
		public static function getDataModule($IdModule)
		{
			$Path = "./custom/modules/$IdModule/base.info";
			$ListKey = ['Name', 'Tab', 'Status'];

			$Result = DataFromFile::ParseInfoFromFile($Path, $ListKey);

			return $Result;
		}

		public static function getListModules()
		{
			$Path = "./custom/modules";
			$Result = DataFromFile::getListCatalog($Path);

			return $Result;
		}
		
	}

	class DataFromFile
	{
		public function ParseInfoFromFile($Path, $Keys = NULL)
		{
			$FileText = self::getFileText($Path);
			$Result = self::ParseInfo($FileText, $Keys);

			return $Result;
		}

		public static function ParseInfo($FileText, $Keys = NULL)
		{
			$Reg = '/([A-z]+)\s*=\s*(.+)/';
			preg_match_all($Reg, $FileText, $Buffer);

			foreach ($Buffer[0] as $index => $val) 
			{
				$key = $Buffer[1][$index];
				$value = $Buffer[2][$index];

				if ( $Keys == NULL or in_array($key, $Keys) )
					$result[$key] = $value; 
			}

			foreach ($Keys as $key) 
				if ( !array_key_exists($key, $result) )
					$result[$key] = "Not_found";

			return $result;
		}

		public static function getFileText($Path)
		{
			if ( file_exists($Path) )
				$FileText = file_get_contents($Path);
			else
				throw new Exception("File not Found", 1);

			return $FileText;
		}

		public static function getListCatalog($Path)
		{
			$catalogs = scandir($Path);
			$catalogs = array_diff($catalogs, array('.', '..'));

			foreach ($catalogs as  $key => $catalog) 
			{
				if ( !is_dir("$Path/$catalog") )
					unset($catalogs[$key]);
			}

			return array_values($catalogs);
		}
	}


?>