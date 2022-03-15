#Definición de constantes
set-variable -name logname -value "Application" -option constant
set-variable -name source -value "Application" -option constant
set-variable -name ubicacion -value "E:\scripts\EmpleadosBCCR.csv" -option constant

#Importamos la lista de usuarios proporcionados por recursos humanos, extraidos por job de BD
$lista = import-Csv $ubicacion

#Función Encargada de obtener del string $ENTRADA (ALIAS Y JEFE) Y AGREGARLO A MANAGER EN EL AD
function LlamaFuncManager($entrada) {
    try{
            Set-ADUser $entrada.Alias -Manager $entrada.Jefe
        } catch {
            Write-Host "Oops, algo fallo!, en agregar Manager"
        }
}

#Función Encargada de obtener un Usuario de AD
function Get-ADUser( [string]$samid=$env:username){
     $searcher=New-Object DirectoryServices.DirectorySearcher
     $searcher.Filter="(&(objectcategory=person)(objectclass=user)(sAMAccountname=$samid))"
     $user=$searcher.FindOne()
      if ($user -ne $null ){
          $user.getdirectoryentry()
     }
}

# Se recorre cada entrada del archivo de datos, luego se consulta el usuario en AD y se actualiza la información
foreach($entrada in $lista)
{
    try
    {
        #Obtenemos el usuario de AD, la propiedad Alias contiene el valor del codigo de usuario
        $user = Get-ADUser $entrada.Alias
    	  
        if ($user -ne $null) 
        {
            #$user.psbase.properties
            # Actualizamos las propiedades en AD
            $user.extensionAttribute2 = $entrada.Cedula
            $user.givenName = $entrada.Nombre
            $user.sn = $entrada.Apellidos
            if ($entrada.SegundoNombre)
            {
                $user.middleName = $entrada.SegundoNombre
            }
            $user.displayName = $entrada.NombreCompleto
            #$user.alias = $entrada.Alias
            $user.l = $entrada.Ciudad
            $user.st = $entrada.Provincia
            $user.co = $entrada.Pais
            $user.title = $entrada.Puesto
            $user.company = $entrada.Compania
            $user.division = $entrada.Division
            $user.department = $entrada.Departamento
            $user.physicalDeliveryOfficeName = $entrada.Oficina
       	    $user.ipPhone = $entrada.Extension            
            $user.telephoneNumber = $entrada.Telefono
            $user.extensionAttribute3 = $entrada.CodInterno
            $user.c = "CR"
            # Enviamos a hacer la actualizacion en AD
            $user.SetInfo()
            #Función Encargada de obtener del string $ENTRADA (ALIAS Y JEFE) Y AGREGARLO A MANAGER EN EL AD
            LlamaFuncManager ($entrada)
            
    	}
        else
        {
            # El usuario no se encuentra en active directory
            $mensaje = "Error el usuario: " + $entrada.Alias + " no se encuentra registrado en Active Directory."
            Write-Eventlog -logname $logname -source $source -eventID 1010 -EntryType Error -message $mensaje
        }
    }
    catch
    {
        $mensaje = "Error al actualizar el usuario: " + $entrada.Alias + " Excepcion: " + $_.Exception.Message
        Write-Eventlog -logname $logname -source $source -eventID 1000 -EntryType Error -message $mensaje
        Write-Output -logname $logname -source $source -eventID 1000 -EntryType Error -message $mensaje
    }
}
