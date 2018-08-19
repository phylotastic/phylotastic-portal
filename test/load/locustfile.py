from locust import HttpLocust, TaskSet, task
from pyquery import PyQuery

class UserBehavior(TaskSet):
    min_wait = 5000
    max_wait = 20000

    @task(1)
    def index(self):
        self.client.get("/")

    @task(1)
    def create_list(self):
        r = self.client.get("/links/new")
        pq = PyQuery(r.content)
        authen_token = pq("meta[name='csrf-token']")
        
        self.client.post("/links",
                         {
                           "link[url]": "https://en.wikipedia.org/wiki/Muroidea",
                           "name": "Muroidea",
                           "authenticity_token": authen_token[0].attrib["content"]
                         })

class WebsiteUser(HttpLocust):
    task_set = UserBehavior