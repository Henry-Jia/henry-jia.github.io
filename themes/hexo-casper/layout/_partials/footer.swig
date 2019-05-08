{# footer #}

{% include "search.swig" %}

<footer class="site-footer outer">
<script async src="//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
	<div class="site-footer-content inner">
		<section class="copyright">
			<a href="{{ config.root }}" title="{{ config.title }}">{{ config.title }}</a>
			&copy; {{ date(Date.now(), 'YYYY') }}
		</section>
		<section class="count">
			<span id="busuanzi_container_site_uv">总访客：<span id="busuanzi_value_site_uv"></span>次</span>
			&nbsp;💖&nbsp;
			<span id="busuanzi_container_site_pv">总浏览：<span id="busuanzi_value_site_pv"></span>次</span>
		</section>
            	<nav class="site-footer-nav">
            		{% for key,link in theme.footer %}
            		<a href="{{ link }}" title="{{ key }}" target="_blank" rel="noopener">{{ key }}</a>
            		{% endfor %}
            		{{ link_to('https://hexo.io', 'Hexo', {external: true})}}
            		{{ link_to('https://github.com/xzhih/hexo-theme-casper', 'Casper', {external: true})}}
            	</nav>
        </div>
</footer>
