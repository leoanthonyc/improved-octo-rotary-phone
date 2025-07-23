require_relative '../client_list'

RSpec.describe ClientList do
  describe '.find_by_name' do
    context 'when name matches clients' do
      it 'returns an array with the clients in it' do
        result = ClientList.find_by_name('spec/files/clients.json', 'John')
        expect(result.size).to eq 2
        expect(result.map { |c| c['full_name'] }).to include('John Doe', 'Alex Johnson')
      end
    end

    context 'when name does not match a client' do
      it 'returns a blank array' do
        result = ClientList.find_by_name('spec/files/clients.json', 'Mary')
        expect(result.size).to eq 0
      end
    end

    context 'when file does not exist' do
      it 'raises an error' do
        expect do
          ClientList.find_by_name('secret-clients.json', 'Grog')
        end.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe '.duplicates_by_email' do
    context 'when there are clients with duplicate emails' do
      it 'returns group of clients with duplicate emails' do
        result = ClientList.duplicates_by_email('spec/files/clients.json')
        expect(result).to have_key('jane.smith@yahoo.com')
        expect(result['jane.smith@yahoo.com'].map { |c| c['full_name'] }).to include('Jane Smith', 'Another Jane Smith')
      end
    end

    context 'when there are no clients with duplicate emails' do
      it 'returns a blank array' do
        result = ClientList.duplicates_by_email('spec/files/deduplicated-clients.json')
        expect(result.size).to eq 0
      end
    end

    context 'when file does not exist' do
      it 'raises an error' do
        expect do
          ClientList.duplicates_by_email('secret-clients.json')
        end.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe '.find_by' do
    context 'when multiple conditions are passed' do
      it 'returns a list of clients matching all the conditions' do
        result = ClientList.find_by('spec/files/clients.json', ['full_name=Michael Brown', 'email=michael.brown@inbox.com'])
        expect(result.size).to eq 1
      end

      it 'returns an empty array if at least one condition does not match a client' do
        result = ClientList.find_by('spec/files/clients.json', ['full_name=Michael Jordan', 'email=michael.brown@inbox.com'])
        expect(result.size).to eq 0
      end
    end

    context 'when one condition is passed' do
      it 'returns a list of clients matching the condition' do
        result = ClientList.find_by('spec/files/clients.json', ['email=michael.brown@inbox.com'])
        expect(result.size).to eq 1
      end
    end

    context 'when an invalid condition is passed' do
      it 'ignores the invalid condition' do
        result = ClientList.find_by('spec/files/clients.json', ['gender=M'])
        expect(result.size).to eq 0
      end
    end

    context 'when file does not exist' do
      it 'raises an error' do
        expect do
          ClientList.find_by('secret-clients.json', 'name=John')
        end.to raise_error(Errno::ENOENT)
      end
    end
  end
end
