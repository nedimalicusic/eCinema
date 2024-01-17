using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class SeatsService : BaseService<Seat, SeatDto, SeatUpsertDto, BaseSearchObject, ISeatsRepository>, ISeatsService
    {
        protected readonly ICinemasRepository _cinemasRepository;

        public SeatsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<SeatUpsertDto> validator, ICinemasRepository cinemasRepository) : base(mapper, unitOfWork, validator)
        {
            _cinemasRepository = cinemasRepository;
        }

        public async Task<IEnumerable<SeatDto>> GetAllSeatsByCinemaId(int cinemaId, CancellationToken cancellationToken)
        {
            var cinema=await _cinemasRepository.GetByIdAsync(cinemaId,cancellationToken);

            var seats = await CurrentRepository.GetAllSeatsByCinemaId(cinema.NumberOfSeats, cancellationToken);

            return Mapper.Map<IEnumerable<SeatDto>>(seats);
        }
    }
}
