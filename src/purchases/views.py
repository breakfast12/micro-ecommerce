from django.shortcuts import render
from django.http import HttpResponse, HttpResponseBadRequest
from products.models import Product
from .models import Purchase

# Create your views here.

def purchase_start_view(request):
    if request.method != "POST":
        return HttpResponseBadRequest()
    if not request.user.is_authenticated:
        return HttpResponseBadRequest()
    
    handle = request.POST.get("handle")
    obj = Product.objects.get(handle=handle)
    purchase = Purchase.objects.create(user=request.user, product=obj)
    request.session['purchase_id'] = purchase.id
    return HttpResponse("Started")

def purchase_success_view(request):
    purchase_id = request.session.get("purchase_id")
    if purchase_id:
        purchase = Purchase.objects.get(id=purchase_id)
        purchase.completed = True
        purchase.save()
    return HttpResponse("Success")

def purchase_stopped_view(request):
    return HttpResponse("Stopped")
