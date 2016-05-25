# -*- python -*-
import os

env = Environment(ENV=os.environ)

env.Append(BUILDERS={
             'Epub': Builder(action='pandoc --mathml -o $TARGET $SOURCES'),
	     'Mobi': Builder(action='ebook-convert $SOURCE $TARGET')})
SOURCES = ['title.yaml'] + Glob('*.ch???.md')
pdf = env.Epub(target='example.pdf', source=SOURCES)
epub = env.Epub(target='example.epub', source=SOURCES)
mobi = env.Mobi(target='example.mobi', source='example.epub')

Depends(mobi, epub)

