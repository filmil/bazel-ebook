# -*- python -*-
import os

env = Environment(ENV=os.environ)

env.Append(BUILDERS={
    'Asy': Builder(
	action='asy -render 5 -f png -o $TARGET $SOURCE',
	suffix='.asy.png', src_suffix='.asy',
    ),
    'Gladtex': Builder(
        action='gladtex -r 200  -d outdir $SOURCES'),
    'Htex': Builder(action='pandoc -s --gladtex -o $TARGET $SOURCES'),
    'HtexEpub': Builder(action='pandoc --epub-metadata=epub-metadata.xml -f html -t epub3 $SOURCES -o $TARGET'),
    'EpubDirect': Builder(action='pandoc --epub-metadata=epub-metadata.xml ' + 
                           '--mathml -o $TARGET $SOURCES'),
    'Mobi': Builder(action='ebook-convert $SOURCE $TARGET')})

SOURCES = Glob('*.ch???.md')
pdf = env.EpubDirect(target='book.pdf', source=SOURCES)
epub_direct = env.EpubDirect(target='book-direct.epub', source=SOURCES)
htex = env.Htex(target='book.htex', source=SOURCES)
gladtex = env.Gladtex(target='book.html', source='book.htex')
htexepub = env.HtexEpub(target='book.epub', source='book.html')

# Images.
img01 = env.Asy('test')

Dir('outdir')
mobi = env.Mobi(target='book.mobi', source='book.epub')

Depends(pdf, File('epub-metadata.xml'))

Depends(mobi, htexepub)
Depends(gladtex, htex)
Depends(Dir('outdir'), gladtex)

Depends(htexepub, File('epub-metadata.xml'))
Depends(htexepub, Dir('outdir'))
Depends(htexepub, gladtex)
Depends(htexepub, htex)

Depends(epub_direct, img01)
Depends(htexepub, img01)
Depends(pdf, img01)

