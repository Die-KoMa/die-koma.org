---
title: Publikationen
menutitle: Publikationen
order: 50
---

# Publikationen der KoMa

Folgende Publikationen werden von der KoMa veröffentlicht:
<ul>
{% for item in site.pages %}
{% assign item_crumbs = item.url | remove_first: page.dir | split: '/' %}
{% if item_crumbs.size == 1 %}
<li>
    <a href="{{ item.url | relative_url }}">{{ item.title }}</a>
</li>
{% endif %}
{% endfor %}
</ul>