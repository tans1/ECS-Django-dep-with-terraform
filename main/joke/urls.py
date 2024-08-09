from django.urls import path, include
from .views import index, getJoke

urlpatterns = [
    path('', index),
    path('joke/', getJoke)
]
