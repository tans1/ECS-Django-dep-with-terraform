import requests
from django.shortcuts import render


def index(request):
    return render(request, template_name="index.html")

def getJoke(request):
    res = requests.get('https://v2.jokeapi.dev/joke/Programming?type=twopart')
    data = res.json()
    
    return render(request,template_name="joke.html", context={"joke" : data})

