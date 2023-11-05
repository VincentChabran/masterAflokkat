from django.urls import path
from .views import home, guess

urlpatterns = [
    path('', home, name="home"),
    path('guess/', guess, name="guess")
]