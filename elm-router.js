function ElmRouter () {
    this.routes = [];           // [{ routeMatch: Regex, routeId: String, title: String }]
    this.defaultRoute = null;
}

ElmRouter.prototype.when = function (routeMatch, routeId, title) {
    this.routes.push({
        'routeMatch': routeMatch,
        'routeId': routeId,
        'title': title
    });

    return this;
}

ElmRouter.prototype.otherwise = function (routeId, title) {
    this.defaultRoute = {
        'routeId': routeId,
        'title': title
    };

    return this;
}

ElmRouter.prototype.route = function (url) {
    if (!url) url = window.location.pathname + window.location.search;
    
    // Return the matching route
    for (var i = 0; i < this.routes.length; i++) {
        var result = this.routes[i].routeMatch.exec(url);
        if (result !== null) {
            return {
                'url': url,
                'routeId': this.routes[i].routeId,
                'routeData': result.slice(1)
            };
        }
    }

    return {
        'url': url,
        'routeId': this.defaultRoute.routeId,
        'routeData': []
    };
}
