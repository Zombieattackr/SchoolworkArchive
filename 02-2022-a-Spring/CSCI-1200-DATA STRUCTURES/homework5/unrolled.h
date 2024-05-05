#ifndef unrolled_h_
#define unrolled_h_
// A simplified implementation of the STL list container class,
// including the iterator, but not the const_iterators.  Three
// separate classes are defined: a Node class, an iterator class, and
// the actual list class.  The underlying list is doubly-linked, but
// there is no dummy head node and the list is not circular.
#include <cassert>

const int NUM_ELEMENTS_PER_NODE = 6;

// -----------------------------------------------------------------
// NODE CLASS
template <class T>
class Node {
public:
  Node() : next_(NULL), prev_(NULL) {}
  Node(const T& v) {
    value_[0]=v;
    next_=NULL;
    prev_=NULL;
    elems=1;
  }

  // REPRESENTATION
  T value_[NUM_ELEMENTS_PER_NODE];
  Node<T>* next_;
  Node<T>* prev_;
  int elems;
};

// A "forward declaration" of this class is needed
template <class T> class UnrolledLL;

// -----------------------------------------------------------------
// LIST ITERATOR
template <class T>
class list_iterator {
public:
  // default constructor, copy constructor, assignment operator, & destructor
  list_iterator(Node<T>* p=NULL, int o=0) : ptr_(p), pos(o) {}
  //list_iterator(Node<T>* p, int o) : ptr_(p), pos(o) {}
  // NOTE: the implicit compiler definitions of the copy constructor,
  // assignment operator, and destructor are correct for this class

  // dereferencing operator gives access to the value at the pointer //done
  T& operator*()  { 
    //debug print
    //std::cerr << "EEEEEEEEEEEEEEEEE" << ptr_ << " " << pos << "/" << ptr_->elems << std::endl;
    return ptr_->value_[pos];  }

  // increment & decrement operators
  list_iterator<T>& operator++() { // pre-increment, e.g., ++iter
    if(pos>=ptr_->elems-1) {
      ptr_ = ptr_->next_;
      pos = 0;
    } else {
      pos++;
    }
    return *this;
  }
  list_iterator<T> operator++(int) { // post-increment, e.g., iter++
    list_iterator<T> temp(*this);
    if(pos>=ptr_->elems-1) {
      ptr_ = ptr_->next_;
      pos = 0;
    } else {
      pos++;
    }
    return temp;
  }
  list_iterator<T>& operator--() { // pre-decrement, e.g., --iter
    if(pos==0) {
      ptr_ = ptr_->prev_;
      pos = ptr_->elems-1;
    } else {
      pos--;
    }
    return *this;
  }
  list_iterator<T> operator--(int) { // post-decrement, e.g., iter--
    list_iterator<T> temp(*this);
    if(pos==0) {
      ptr_ = ptr_->prev_;
      pos = ptr_->elems-1;
    } else {
      pos--;
    }
    return temp;
  }
  // the UnrolledLL class needs access to the private ptr_ member variable
  friend class UnrolledLL<T>;

  // Comparions operators are straightforward
  bool operator==(const list_iterator<T>& r) const {
    if(ptr_==NULL && r.ptr_==NULL && (pos==0 || r.pos==0)) {
      return true;
    }
    return (ptr_ == r.ptr_ && pos == r.pos); }
  bool operator!=(const list_iterator<T>& r) const {
    if(ptr_==NULL && r.ptr_==NULL && (pos==0 || r.pos==0)) {
      return false;
    }
    return (ptr_ != r.ptr_ || pos != r.pos); 
  }

private:
  // REPRESENTATION
  Node<T>* ptr_;    // ptr to node in the list
  int pos;
};

// -----------------------------------------------------------------
// LIST CLASS DECLARATION
// Note that it explicitly maintains the size of the list.
template <class T>
class UnrolledLL {
public:
  // default constructor, copy constructor, assignment operator, & destructor
  UnrolledLL() : head_(NULL), tail_(NULL), size_(0) {}
  UnrolledLL(const UnrolledLL<T>& old) { copy_list(old); }
  UnrolledLL& operator= (const UnrolledLL<T>& old);
  ~UnrolledLL() { destroy_list(); }

  typedef list_iterator<T> iterator;

  // simple accessors & modifiers
  unsigned int size() const { return size_; }
  bool empty() const { return head_ == NULL; }
  void clear() { destroy_list(); }

  // read/write access to contents
  const T& front() const { return head_->value_[0];  }
  T& front() { return head_->value_[0]; }
  const T& back() const { return tail_->value_[tail_->elems-1]; }
  T& back() { return tail_->value_[tail_->elems-1]; }

  // modify the linked list structure
  void push_front(const T& v);
  void pop_front();
  void push_back(const T& v);
  void pop_back();

  iterator erase(iterator itr);
  iterator insert(iterator itr, const T& v);
  iterator begin() { return iterator(head_,0); }
  iterator end() { 
    return iterator(NULL,0);
  }

  void print(std::ostream& ostr);

private:
  // private helper functions
  void copy_list(const UnrolledLL<T>& old);
  void destroy_list();

  //REPRESENTATION
  Node<T>* head_;
  Node<T>* tail_;
  unsigned int size_;
};

// -----------------------------------------------------------------
// LIST CLASS IMPLEMENTATION
template <class T>
UnrolledLL<T>& UnrolledLL<T>::operator= (const UnrolledLL<T>& old) {
  // check for self-assignment
  if (&old != this) {
    destroy_list();
    copy_list(old);
  }
  return *this;
}

template <class T> //done
void UnrolledLL<T>::push_front(const T& v) {
  //Node<T>* newp = new Node<T>(v);
  if (!head_) {
    // initially empty list as a special case
    Node<T>* newp = new Node<T>(v);
    head_ = tail_ = newp;
  } else {
    // normal case: at least one node
    if(head_->elems == NUM_ELEMENTS_PER_NODE) {
      //special: head node is full
      Node<T>* newp = new Node<T>(v);
      newp->next_ = head_;
      head_->prev_ = newp;
      head_ = newp;
    } else {
      //normal: head node is not full
      for(int i = head_->elems; i > 0; i--) {
        head_->value_[i] = head_->value_[i-1];
      }
      head_->value_[0] = v;
      head_->elems++;
    }
    
  }
  ++size_;
}

template <class T> 
void UnrolledLL<T>::pop_front() {
  if(head_->elems == 1) {
    //special: if node is empty
    Node<T>* oldp = head_;
    if (head_ == tail_) {
      // special case: deleting the last node
      head_ = tail_ = 0;
    } else {
      // normal case
      head_ = head_->next_;
    }
    // remove node as the last operator
    delete oldp;
  } else {
    //normal: if node is not empty
    for(int i = 0; i<head_->elems-1;i++) {
      head_->value_[i] = head_->value_[i+1];
    }
    head_->value_[head_->elems-1]=0;
    head_->elems--;
  }
  --size_;
}

template <class T> 
void UnrolledLL<T>::push_back(const T& v) {
  // special case: initially empty list
  if (!tail_) {
    Node<T>* newp = new Node<T>(v);
    head_ = tail_ = newp;
  } else {
    // normal case: at least one node already
    if(tail_->elems == NUM_ELEMENTS_PER_NODE) {
      //special: tail node is full
      Node<T>* newp = new Node<T>(v);
      newp->prev_ = tail_;
      tail_->next_ = newp;
      tail_ = newp;
    } else {
      //normal: tail node is not full
      tail_->value_[tail_-> elems] = v;
      tail_->elems++;
    }
  }
  ++size_;
}

template <class T> 
void UnrolledLL<T>::pop_back() {
  Node<T>* oldp = tail_;
  if(tail_->elems == 1) {
    //special: if node is empty 
      if (head_ == tail_) {
      // special case: deleting the last node
      head_ = tail_ = 0;
    } else {
      // normal case
      tail_->prev_->next_ = NULL;
      tail_ = tail_->prev_;
    }
    delete oldp;
  } else {
    //normal: if node is not empty
    tail_->value_[tail_->elems-1] = NULL;
    tail_->elems--;
  }
  --size_;
}

// do these lists look the same (length & contents)?
template <class T>
bool operator== (UnrolledLL<T>& left, UnrolledLL<T>& right) {
  if (left.size() != right.size()) return false;
  typename UnrolledLL<T>::iterator left_itr = left.begin();
  typename UnrolledLL<T>::iterator right_itr = right.begin();
  // walk over both lists, looking for a mismatched value
  while (left_itr != left.end()) {
    if (*left_itr != *right_itr) return false;
    left_itr++; right_itr++;
  }
  return true;
}

template <class T>
bool operator!= (UnrolledLL<T>& left, UnrolledLL<T>& right){ return !(left==right); }

template <class T>
typename UnrolledLL<T>::iterator UnrolledLL<T>::erase(iterator itr) {
  assert (size_ > 0);
  iterator result(itr.ptr_,itr.pos);
  if (itr.ptr_ == head_ && head_ == tail_ && itr.ptr_->elems == 1) {
    head_ = tail_ = 0;
    delete itr.ptr_;
    --size_;
  }
  // Removing the head in a list with at least two nodes
  else if (itr.ptr_ == head_ && itr.ptr_->elems == 1) {
    head_ = head_->next_;
    head_->prev_ = 0;
    delete itr.ptr_;
    --size_;
  }
  // Removing the tail in a list with at least two nodes
  else if (itr.ptr_ == tail_ && itr.ptr_->elems == 1) {
    tail_ = tail_->prev_;
    tail_->next_ = 0;
    delete itr.ptr_;
    --size_;
  }
  // Normal remove
  else {
    if(itr.ptr_->elems == 1) {//special: if one remains in the node
      result.ptr_ = itr.ptr_->next_;
      result.pos = 0;
      itr.ptr_->prev_->next_ = itr.ptr_->next_;
      itr.ptr_->next_->prev_ = itr.ptr_->prev_;
      delete itr.ptr_;
      --size_;
    } else if (itr.pos<itr.ptr_->elems) {//normal: more elements ramain
      if(itr.pos==itr.ptr_->elems-1) {
        result.ptr_ = itr.ptr_->next_;
        result.pos = 0;
      }
      for(int i=itr.pos;i<itr.ptr_->elems-1;i++) {
        itr.ptr_->value_[i] = itr.ptr_->value_[i+1];
      }
      itr.ptr_->elems--;
      --size_;
    }
  }
  return result;
}

template <class T>
typename UnrolledLL<T>::iterator UnrolledLL<T>::insert(iterator itr, const T& v) {
  ++size_ ;
  Node<T>* p;
    if(itr.ptr_->elems == NUM_ELEMENTS_PER_NODE) { //inserting in a full node
    p = new Node<T>(NULL);
    p->elems--;
    p->prev_ = itr.ptr_;
    p->next_ = itr.ptr_->next_;
    itr.ptr_->next_->prev_ = p;
    itr.ptr_->next_ = p;
    if (itr.ptr_ == tail_) {
      tail_ = p;
    }
    int j=0;
    for(int i=itr.pos;i<NUM_ELEMENTS_PER_NODE;i++) {
      p->value_[j] = itr.ptr_->value_[i];
      itr.ptr_->value_[i] = NULL;
      j++;
      itr.ptr_->elems--;
      p->elems++;
    }
    itr.ptr_->value_[itr.pos] = v;
    itr.ptr_->elems++;
  } else { // inserting into a non full node
    itr.ptr_->elems++;
    for(int i=itr.ptr_->elems-1;i>itr.pos;i--) {
      itr.ptr_->value_[i] = itr.ptr_->value_[i-1];
    }
    itr.ptr_->value_[itr.pos] = v;
  }
  return iterator(itr.ptr_,itr.pos);
}

template <class T>
void UnrolledLL<T>::copy_list(const UnrolledLL<T>& old) {
  size_ = old.size_;

  // Handle the special case of an empty list.
  if (size_ == 0) {
    head_ = tail_ = NULL;
    return;
  } 
  // Create a new head node.
  head_ = new Node<T>(old.head_->value_[0]);
  for(int i=1;i<old.head_->elems;i++) {
    head_->elems++;
    head_->value_[i] = old.head_->value_[i];
  }
  // tail_ will point to the last node created and therefore will move
  // down the new list as it is built
  tail_ = head_;
  // old_p will point to the next node to be copied in the old list
  Node<T>* old_p = old.head_->next_;
  // copy the remainder of the old list, one node at a time
  while (old_p) {
    tail_->next_ = new Node<T>(old_p->value_[0]);
    tail_->next_->prev_ = tail_;
    tail_ = tail_->next_;
    for(int i=1;i<old_p->elems;i++) {
      tail_->elems++;
      tail_->value_[i] = old_p->value_[i];
    }
    old_p = old_p->next_;
  }
}

template <class T>
void UnrolledLL<T>::destroy_list() {
  while (head_) {
    Node<T>* p = head_;
    head_ = head_->next_;
    delete p;
  }
  head_ = tail_ = NULL;
  size_ = 0;
}

template <class T>
void UnrolledLL<T>::print(std::ostream& ostr) {
  UnrolledLL<T>::iterator it = iterator(head_,0);
  ostr << "UnrolledLL, size: " << size_;
  while(it != end()) {
    if(it.pos == 0) {
      ostr << std::endl << " node:[" << it.ptr_->elems << "]";
    }
    ostr << " " << it.ptr_->value_[it.pos];
    ++it;
  }
  ostr << std::endl;
}

#endif