/*IONIC CODE
----
private urlObtener = 'https://www.maderosolutions.com.ar/MayorG2/modelo/jugador_modelo10.php';
  private urlComprobar =
    'https://www.maderosolutions.com.ar/MayorG2/modelo/almacenar_historial.php';
  private _pregunta = new BehaviorSubject<Pregunta>(
    new Pregunta({id:null,nivel:null,foto:null,pregunta:'',categoria:'',prescripcion:'',tema:''}, 1, ['', '', '', ''])
  );
----
async obtenerPregunta(dni) {
    return new Promise((resolve)=>{
      this.http.post<any>(this.urlObtener,JSON.stringify(dni),this.httpOptions)
        .subscribe(data => {
          resolve(data);
        })
    })
  }

  get pregunta() {
    return this._pregunta.asObservable();
  }

  enviarDatos(datos) {
    return this.http.post(this.urlComprobar, datos, this.httpOptions);
  }

  // Para que, cuando la app esté cargando una nueva pregunta
  // no se vea la preg anterior atrás del cuadrito de cargando,
  // emito una pregunta vacía momentánea.
  clearPregunta() {
    const preg = new Pregunta({id:null,nivel:null,foto:null,pregunta:'',categoria:'',prescripcion:'',tema:''}, 1, ['', '', '', '']);
    this._pregunta.next(preg);
  }
 */