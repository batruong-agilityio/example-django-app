from rest_framework import viewsets

from tasks.models import Task
from tasks.serializers import TaskSerializer


class TaskViewSet(viewsets.ModelViewSet):
    """
    Task CRUD
    """
    queryset = Task.objects.all()
    serializer_class = TaskSerializer