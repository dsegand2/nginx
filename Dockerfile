#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
ARG									\
	digest="@sha256:a411d06ab4f5347ac9652357ac35600555aeff0b910326cc7adc36d471e0b36f"
ARG									\
	tag=":1.19.3-alpine"
#########################################################################
FROM									\
	nginx${tag}${digest}						\
		AS nginx
#########################################################################
RUN									\
	for package in							\
		$(							\
			for x in 0 1 2 3 4 5 6 7 8 9;			\
			do						\
				apk list				\
				| awk /nginx/'{ print $1 }'		\
				| awk -F-$x  '{ print $1 }'		\
				| grep -v '\-[0-9]';			\
			done						\
			| sort						\
			| uniq						\
			| grep -v ^nginx$				\
		);							\
	do								\
		apk del $package;					\
	done								\
									;
#########################################################################
RUN									\
	rm 	-f 							\
			/etc/nginx/nginx.conf				\
	&& 								\
	rm 	-f 							\
		-r 	/etc/nginx/conf.d/*				\
#	&& 								\
#	ln	-s							\
#			/run/nginx/etc/nginx/nginx.conf			\
#			/etc/nginx/nginx.conf				\
									;
#########################################################################
VOLUME									\
	/var/cache/nginx						\
	/var/run							\
#########################################################################
