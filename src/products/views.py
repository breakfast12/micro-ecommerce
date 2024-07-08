from django.shortcuts import render, redirect

from .forms import ProductForm
from .models import Product

# Create your views here.

def product_create_view(request):
    context = {}
    form = ProductForm(request.POST or None)
    if form.is_valid():
        obj = form.save(commit=False)
        if request.user.is_authenticated:
            obj.user = request.user
            obj.save()
            return redirect('/products/create/')
        form.add_error(None, "Your must be logged in to create products.")
    context['form'] = form
    return render(request, 'products/create.html', context)
