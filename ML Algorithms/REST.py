from flask import Flask 
from flask_restful import reparse, abort, APi, Resource
import pickel
import numpy as np
from model import NLPModel

app = Flask(__name__)
api = Api(app)

model = NLPModel;