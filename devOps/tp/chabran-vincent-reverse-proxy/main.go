package main

import (
	"html/template"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"path"
)

var (
	version     string = "0.0.0-local"
	certsDir           = "certs"
	serverCertPath     = path.Join(certsDir, "server.crt")
	serverKeyPath      = path.Join(certsDir, "server.key")
	pingTemplate, _    = template.New("").Parse(`<html>
<title>Gateway</title>
<style>
html
{
	background: linear-gradient(0.25turn, rgb(2,0,36) 0%, rgb(59,9,121) 50%, rgb(0,21,66) 100%);
	color: #fafafa;
	margin: 0;
	padding: 10px;
}
</style>
<h1>ping success v{{.}}</h1>
</html>`)
	
)

func main() {
	server := &http.Server{
		Addr:    ":4443",
		Handler: logReq(proxyHandler()),
	}

	log.Printf("Serveur démarré avec %v, %v, en écoute sur %v\n", serverCertPath, serverKeyPath, server.Addr)
	log.Fatal(server.ListenAndServe())
}

// Fonction de haut niveau pour générer un journal pour chaque requête entrante
// logReq est une fonction middleware qui enregistre les requêtes entrantes.
// Elle prend un http.Handler en entrée et renvoie un http.Handler.
// Le http.Handler renvoyé enregistre les détails de la requête entrante
// avant de la transmettre au prochain gestionnaire dans la chaîne.
//
// Paramètres :
//   - next : Le prochain http.Handler dans la chaîne.
//
// Renvoie :
//   - http.Handler : Le gestionnaire de requête enregistré.
//
// Exemple d'utilisation :
//   router := http.NewServeMux()
//   router.HandleFunc("/", handler)
//   loggedRouter := logReq(router)
//   http.ListenAndServe(":8080", loggedRouter)
func logReq(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Nouvelle requête de '%s', endpoint: '%s %s'", r.RemoteAddr, r.Method, r.RequestURI)
		next.ServeHTTP(w, r)
	})
}

// proxyHandler retourne un gestionnaire HTTP qui agit comme un reverse proxy.
// Il redirige les requêtes vers le backend suivant et sert directement la route "/ping".
func proxyHandler() http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/ping" {
			// Servir directement la route ping
			pingTemplate.ExecuteTemplate(w, "", version)
			return
		}
		proxy := httputil.NewSingleHostReverseProxy(&url.URL{Scheme: "http", Host: "api:8080"})	
		proxy.ServeHTTP(w, r)
	})
}

