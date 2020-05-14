/*IONIC CODE
----
MODELO LISTA*
----
    private urlObtener = 'https://www.maderosolutions.com.ar/MayorG2/modelo/getNoAmigos.php';
    private urlEnviar = 'https://www.maderosolutions.com.ar/MayorG2/modelo/enviarSolicitudAmistad.php';
----
GetUsers(dni){
        return new Promise(resolve => {
            this.http.post(this.urlObtener,JSON.stringify(dni),{headers : this.headers})
            .subscribe((res: any) => {
                if (res == null){ return []; }
                for ( var i=0; i < res.noAmigos.length ; i++ ){
                    this.lista[i] = res.noAmigos[i]; //noAmigos
                }
                resolve(this.lista)
            })                
        })
    }

    SendRequest(dni){
        return new Promise(resolve => {
            this.http.post(this.urlEnviar,JSON.stringify(dni),{headers : this.headers})
                .subscribe((res : any) =>{
                    resolve(res.estado)
                })
        })

    }
 */