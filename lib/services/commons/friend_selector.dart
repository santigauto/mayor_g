/*IONIC CODE
----
MODELO LISTA*
----
private urlObtener = 'https://www.maderosolutions.com.ar/MayorG2/modelo/getAmigos.php';
----
GetFriends(dni){
        this.http.post(this.urlObtener, JSON.stringify(dni))
            .subscribe((res: any) => {
                if (res == null){ return []; }

            for ( var i=0; i < res.amigos.length ; i++ ){
                this.lista*[i] = res.amigos[i]; //noAmigos
            }
            }), 
            {headers : this.headers}
        return this.lista*
    }
 */