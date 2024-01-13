---
title: Liederbuch
menutitle: Liederbuch
order: 7
---

# Liederbuch

Traditionell findet auf der KoMa der AK Pella statt. Dieser hat sich der Aufgabe verschrieben, klassische bekannte Lieder zu nehmen und sie mit mathematischen Texten zu versehen. Die aktuelle Version des Liederbuches findet ihr hier zum download.

## Liederbuch

[Download](https://file.komapedia.org/KoMa-Liederbuch.pdf) (Stand: 14. Nov 2022)

## Einzellieder
<ul>
{% for item in site.pages %}
    {% assign item_crumbs = item.url | remove_first: page.dir | split: '/' %}
    {% if item_crumbs.size == 1  %}
    <li>
        <a href="{{ item.url | relative_url }}">{{ item.title }}</a>
    </li>
    {% endif %}
{% endfor %}
</ul>
