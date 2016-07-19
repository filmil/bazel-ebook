# -*- python -*-
import os

env = Environment(ENV=os.environ)

env.Append(BUILDERS={
    'Gladtex': Builder(
        action='python3 ../gladtex/gladtex.py -r 300 -d outdir $SOURCES'),
    'Htex': Builder(action='pandoc -s --gladtex -o $TARGET $SOURCES'),
    'HtexEpub': Builder(action='pandoc --epub-metadata=epub-metadata.xml -f html -t epub3 $SOURCES -o $TARGET'),
    'EpubDirect': Builder(action='pandoc --epub-metadata=epub-metadata.xml ' + 
                           '--mathml -o $TARGET $SOURCES'),
    'Mobi': Builder(action='ebook-convert $SOURCE $TARGET')})

SOURCES = Glob('*.ch???.md')
pdf = env.EpubDirect(target='example.pdf', source=SOURCES)
epub_direct = env.EpubDirect(target='example-direct.epub', source=SOURCES)
htex = env.Htex(target='example.htex', source=SOURCES)
gladtex = env.Gladtex(target='example.html', source='example.htex')
htexepub = env.HtexEpub(target='example.epub', source='example.html')

Dir('outdir')
mobi = env.Mobi(target='example.mobi', source='example.epub')

#Depends(mobi, epub)
Depends(pdf, File('epub-metadata.xml'))
Depends(mobi, htexepub)
Depends(gladtex, htex)
Depends(Dir('outdir'), gladtex)
Depends(htexepub, File('epub-metadata.xml'))
Depends(htexepub, Dir('outdir'))
Depends(htexepub, gladtex)
Depends(htexepub, htex)
