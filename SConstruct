# -*- python -*-
import os

env = Environment(ENV=os.environ)

env.Append(BUILDERS={
             'Epub': Builder(action='pandoc --mathml -o $TARGET $SOURCES'),
	     'Mobi': Builder(action='ebook-convert $SOURCE $TARGET')})
pdf = env.Epub(target='example.pdf', source=Glob('*.ch???.md'))
epub = env.Epub(target='example.epub', source=Glob('*.ch???.md'))
mobi = env.Mobi(target='example.mobi', source='example.epub')

Depends(mobi, epub)

