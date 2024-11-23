---
layout: page
title: Discography
permalink: /discography/
---
<ul>
  {% for post in site.categories.discography %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      <!-- <p>{{ post.excerpt }}</p> -->
    </li>
  {% endfor %}
</ul>