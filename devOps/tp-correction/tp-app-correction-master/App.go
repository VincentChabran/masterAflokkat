package main

import "embed"
import "encoding/json"
import "net/http"

import "gitlab.com/ggpack/webstream"

//go:embed swagger-ui
var content embed.FS

func logReq(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		Logger.Infof("New request to: '%s %s'", r.Method, r.RequestURI)
		next.ServeHTTP(w, r)
	})
}

func newApp() http.Handler {
	Logger.Info("Init the backend")

	mux := http.NewServeMux()
	mux.HandleFunc("GET /{$}", getHomeHandler)
	mux.HandleFunc("POST /api/cats", makeHandlerFunc(createCat))
	mux.HandleFunc("GET /api/cats", makeHandlerFunc(listCats))
	mux.HandleFunc("GET /api/cats/{catId}", makeHandlerFunc(getCat))
	mux.HandleFunc("DELETE /api/cats/{catId}", makeHandlerFunc(deleteCat))

	mux.Handle("GET /swagger-ui/", http.FileServerFS(content)) // Match content prefix

	mux.HandleFunc("GET /ws", wsHandler)
	mux.HandleFunc("GET /logs", webstream.UiHandler("/../ws"))

	return logReq(mux)
}

// Simple interface to implement to handle requests
type ServiceFunc func(*http.Request) (int, any)

// Wraps the ServiceFunc to manke a http.HandlerFunc with panic handling and JSON response encoding
func makeHandlerFunc(svcFunc ServiceFunc) http.HandlerFunc {

	return func(res http.ResponseWriter, req *http.Request) {

		code, body := func(req *http.Request) (code int, body any) {
			// General panic/error handler to keep the server up
			defer func() {
				if r := recover(); r != nil {
					Logger.Error("Recovering from a panic: ", r)
					// Using the named return values
					code = http.StatusInternalServerError
					body = http.StatusText(code)
				}
			}()
			return svcFunc(req)
		}(req)

		// Single response
		res.Header().Set("content-type", "application/json")
		res.WriteHeader(code)
		json.NewEncoder(res).Encode(body)
	}
}
