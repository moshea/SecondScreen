require 'singelton'

##
# FifoCache is used to store data in a first in, first out list
# when the list hits its maximum size, the oldest object is removed
# and the latest object is inserted. This cache style is useful where
# only new data in important, and old data becomes less important the 
# older it gets. The list should not be used if all data in the list
# is of equal importance.
# FifoCach is a singleton, so one process can be writing to the cache while
# another process is reading from it. The only thing they need to share is the 
# cache name.

class FifoCache
  include Singleton
  
  ##
  # FifoCache can store multiple caches. On initialize, we set the name
  # of the cache and the size of it
  
  def initialize(name, size=1000)
    @cache_list[name] = []
    @cache_list["#{name}_size"] = size
  end
  
  ##
  # place the new object at the end of the list
  # but check the length of the cache first. if its hitting
  # its limit, remove the oldest object in the queue and then
  # add the latest
  
  def push(name, object)
    if @cache_list[name].length >= @cache_list["#{name}_size"]
      @cache_list[name].shift
    end
    @cache_list[name] << object
  end
  
  ##
  # return the oldest object in the queue
  # and remove the object from the queue. The object cannot be 
  # referenced anymore from the queue
  
  def shift(name, size=0)
    @cache_list[name].shift(size)
  end
end