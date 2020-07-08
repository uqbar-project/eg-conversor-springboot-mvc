package org.uqbar.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Conversor {
	Integer millas = 1

	def kilometros() {
		millas * 1.609344
	}

}
