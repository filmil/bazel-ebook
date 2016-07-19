# -*- python -*-
import os

env = Environment(ENV=os.environ)

env.Append(BUILDERS={
    'Gladtex': Builder(
        action='python3 ../gladtex/gladtex.py -r 300 -d outdir $SOURCES'),
    'Htex': Builder(action='pandoc -s --gladtex -o $TARGET $SOURCES'),
    'HtexEpub': Builder(action='pandoc --epub-metadata=epub-metadata.xml -f html -t epub3 $SOURCES -o $TARGET'),
    'Epub': Builder(action='pandoc --mathml -o $TARGET $SOURCES'),
    'Mobi': Builder(action='ebook-convert $SOURCE $TARGET')})

SOURCES = Glob('*.ch???.md')
SOURCES_WITH_YAML = ['title.yaml'] + SOURCES
SOURCES_WITH_XML = ['epub-metadata.xml'] + SOURCES
pdf = env.Epub(target='example.pdf', source=SOURCES_WITH_YAML)
htex = env.Htex(target='example.htex', source=SOURCES)
gladtex = env.Gladtex(target='example.html', source='example.htex')
htexepub = env.HtexEpub(target='example.epub', source='example.html')

Dir('outdir')
#epub = env.Epub(target='example.epub', source=SOURCES)
mobi = env.Mobi(target='example.mobi', source='example.epub')

#Depends(mobi, epub)
Depends(mobi, htexepub)
Depends(gladtex, htex)
Depends(Dir('outdir'), gladtex)
Depends(htexepub, File('epub-metadata.xml'))
Depends(htexepub, gladtex)
Depends(htexepub, htex)
